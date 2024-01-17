class Language < ApplicationRecord

  default_scope { order(:name) }
  scope :active_languages, -> { where(active: true) }

  validates_uniqueness_of :default, if: proc { |l| l.default }

  def self.default_language
    Language.find_by(default: true) || Language.first
  end

  def self.preferred(accepted_languages)
    default = default_language

    return default if accepted_languages.nil?

    accepted_languages = \
      accepted_languages
        .split(',')
        .map { |x| x.strip.split(';').first.split('-').first }
        .uniq
    return default if accepted_languages.blank?

    possible_languages = \
      active_languages.map { |x| x.locale.match(/\w{2}/).to_s }
    preferred_languages = accepted_languages & possible_languages

    return default if preferred_languages.blank?

    preferred_language = \
      active_languages
        .detect { |x| !(x.locale=~ /^#{preferred_languages.first}/).nil? }

    preferred_language
  end

end
