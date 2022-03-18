class Borrow::ApplicationController < ApplicationController

  layout 'borrow'

  before_action :require_customer, :redirect_if_order_timed_out, :init_breadcrumbs

  def root
    current_user_categories = current_user.all_categories
    @categories = (current_user_categories & Category.roots).sort
    @child_categories = \
      @categories.map { |c| (current_user_categories & c.children).sort }
    @any_template = current_user.templates.any?
  end

  def refresh_timeout
    # ok, refreshed
    respond_to do |format|
      format.html { head :ok }
      date = if current_user.reservations.unsubmitted.empty?
               Time.zone.now
             else
               current_user.reservations.unsubmitted.first.updated_at
             end
      format.json do
        render json: { date: date }
      end
    end
  end

  private

  def require_customer
    require_role :customer
  end

  def redirect_if_order_timed_out
    return if request.format == :json or
              [borrow_order_timed_out_path,
               borrow_order_delete_unavailables_path,
               borrow_order_remove_path,
               borrow_order_remove_reservations_path,
               borrow_change_time_range_path].include? request.path
    if current_user.timeout? \
      and current_user.reservations.unsubmitted.any? { |l| not l.available? }
      redirect_to borrow_order_timed_out_path
    else
      current_user.reservations.unsubmitted.each &:touch
    end
  end

  def init_breadcrumbs
    @bread_crumbs = BreadCrumbs.new params.delete('_bc')
  end

  def user_from_params
    if params[:user_id] && params_user = User.find(params[:user_id])
      if params_user == user_session.user or
          params_user == user_session.delegation or
          (params_user.delegation? and
           params_user.delegated_users.include?(user_session.user))
        params_user
      else
        raise 'User ID not authorized!'
      end
    end
  end

end
