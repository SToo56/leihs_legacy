#!/usr/bin/ruby
require 'faster_csv'
require 'iconv'


# e-mail addresses, one per line, in CSV
names_doz = FasterCSV.read("/tmp/dmu_dozierende-utf8.csv", :col_sep => ';')
names_stud = FasterCSV.read("/tmp/dmu_studenten-utf8.csv", :col_sep => ';')
names_pers = FasterCSV.read("/tmp/dmu_personal-utf8.csv", :col_sep => ';')

name_groups = [names_doz, names_stud, names_pers]

#ic = Iconv.new('ISO-8859-15//TRANSLIT', 'UTF-8')



def add_permissions(user)
  
  if AccessRight.find(:all, :conditions => { :role_id => 3, 
                                             :inventory_pool_id => InventoryPool.find_by_name("DMU").id,
                                             :level => 1,
                                             :user_id => user.id}).count == 0
  
    ar = AccessRight.new
    ar.role = Role.find_by_name("customer")
    ar.inventory_pool = InventoryPool.find_by_name("DMU")
    #ar.access_level = 1
    ar.level = 1
    ar.user = user
    puts "--> AccessRight created" if ar.save
  
  end
 
  
end


def process_names(names)
  
  not_unique = 0
  fine = 0
  not_found = 0
  created = 0
  not_in_ldap = 0

  names.each do |name|
    
    firstname = name[0]
    lastname = name[1]
  
    users = User.find_all_by_firstname_and_lastname(firstname, lastname)

    if users.count > 1
      puts "++++ WARNING: #{firstname} #{lastname} IS NOT UNIQUE"
      not_unique += 1
    elsif users.count == 1
      puts "#{firstname} #{lastname} exists"
      puts "--> Adding permissions."
      add_permissions(users[0])
      fine += 1
    elsif users.nil? or users.count == 0
      #puts "#{firstname} #{lastname} was not found -- creating."
      not_found += 1
      result = `ldapsearch -z 7000 -x -h  '172.30.0.12' -b 'DC=vera,DC=hgka,DC=ch' -LLL "(&(objectclass=user)(givenName=#{firstname})(sn=#{lastname}))" extensionAttribute12`

      if result.blank?
        puts "COULD NOT FIND IN LDAP: #{firstname} #{lastname}"
        not_in_ldap += 1
      else
        evento_id = result.split("extensionAttribute12: ")[1].chomp.strip
        agw_id = "e#{evento_id}|zhdk"
        puts "WOULD CREATE USER:::::::::::::::::::"
        puts "Evento id: #{agw_id}"
        puts "First name: #{firstname}"
        puts "Last name: #{lastname}"
        #user = User.create(bar)
        #created += 1 if user
        #add_permissions(user) 
      end
    end
    

  end
  puts "+--------------------------------------------------------------------------+"
  puts "+ Statistics: #{fine} fine, #{created} created, #{not_unique} not unique, +"
  puts "+ #{not_found} not found locally, #{not_in_ldap} not found in LDAP        +"
  puts "+--------------------------------------------------------------------------+"
end


name_groups.each do |names|
  process_names(names)
end

