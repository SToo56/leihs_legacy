# This file is autogenerated. Instead of editing this file, please use the
# migrations feature of ActiveRecord to incrementally modify your database, and
# then regenerate this schema definition.

ActiveRecord::Schema.define(:version => 5) do

  create_table "attributs", :force => true do |t|
    t.column "lock_version", :integer,   :default => 0,                     :null => false
    t.column "updated_at",   :timestamp,                                    :null => false
    t.column "updater_id",   :integer,   :default => 1
    t.column "created_at",   :timestamp, :default => '2004-01-01 10:10:10', :null => false
    t.column "ding_nr",      :integer,   :default => 0,                     :null => false
    t.column "schluessel",   :string
    t.column "wert",         :string
  end

  create_table "computerdatens", :force => true do |t|
    t.column "lock_version",   :integer,                 :default => 0,                     :null => false
    t.column "updated_at",     :timestamp,                                                  :null => false
    t.column "updater_id",     :integer,                 :default => 1
    t.column "created_at",     :timestamp,               :default => '2004-01-01 10:10:10', :null => false
    t.column "benutzer_login", :string,    :limit => 50
    t.column "ip_adresse",     :string,    :limit => 20
    t.column "ip_maske",       :string,    :limit => 20
    t.column "software",       :text
    t.column "gegenstand_id",  :integer
  end

  create_table "gegenstands", :force => true do |t|
    t.column "lock_version",         :integer,                 :default => 0,                     :null => false
    t.column "updated_at",           :timestamp,                                                  :null => false
    t.column "updater_id",           :integer,                 :default => 1
    t.column "created_at",           :timestamp,               :default => '2005-04-01 00:00:00', :null => false
    t.column "original_id",          :integer
    t.column "name",                 :string
    t.column "hersteller",           :string
    t.column "modellbezeichnung",    :string
    t.column "art",                  :string
    t.column "seriennr",             :string
    t.column "abmessungen",          :string
    t.column "kaufvorgang_id",       :integer
    t.column "bild_url",             :string
    t.column "info_url",             :string
    t.column "inventar_abteilung",   :string,    :limit => 10
    t.column "herausgabe_abteilung", :string,    :limit => 10
    t.column "lagerort",             :string
    t.column "letzte_pruefung",      :date
    t.column "paket_id",             :integer
    t.column "ausleihbar",           :integer,   :limit => 1,  :default => 0
    t.column "ausmusterdatum",       :date
    t.column "ausmustergrund",       :string
    t.column "attribut_id",          :integer
    t.column "kommentar",            :text
  end

  add_index "gegenstands", ["paket_id"], :name => "paket_id"

  create_table "geraeteparks", :force => true do |t|
    t.column "lock_version",        :integer,                 :default => 0,                     :null => false
    t.column "updated_at",          :timestamp,                                                  :null => false
    t.column "updater_id",          :integer,                 :default => 1
    t.column "created_at",          :timestamp,               :default => '2005-10-01 10:00:00', :null => false
    t.column "name",                :string,    :limit => 50, :default => "",                    :null => false
    t.column "logo_url",            :string
    t.column "ansprechpartner",     :text
    t.column "beschreibung",        :text
    t.column "oeffentlich",         :integer,   :limit => 1,  :default => 0,                     :null => false
    t.column "vertrag_bezeichnung", :string
    t.column "vertrag_url",         :string
  end

  create_table "geraeteparks_users", :id => false, :force => true do |t|
    t.column "lock_version",   :integer,   :default => 0,                     :null => false
    t.column "updated_at",     :timestamp,                                    :null => false
    t.column "created_at",     :timestamp, :default => '2005-10-01 10:00:00', :null => false
    t.column "geraetepark_id", :integer,   :default => 0
    t.column "user_id",        :integer,   :default => 0
  end

  create_table "kaufvorgangs", :force => true do |t|
    t.column "lock_version",    :integer,                  :default => 0,                     :null => false
    t.column "updated_at",      :timestamp,                                                   :null => false
    t.column "updater_id",      :integer,                  :default => 1
    t.column "created_at",      :timestamp,                :default => '2004-01-01 10:10:10', :null => false
    t.column "art",             :string
    t.column "lieferant",       :string
    t.column "rechnungsnr",     :string,    :limit => 100
    t.column "kaufdatum",       :date
    t.column "kaufpreis",       :integer
    t.column "abschreibedatum", :date
  end

  create_table "logeintraege", :force => true do |t|
    t.column "lock_version", :integer,                 :default => 0,                     :null => false
    t.column "updated_at",   :timestamp,                                                  :null => false
    t.column "created_at",   :timestamp,               :default => '2006-05-05 10:00:00', :null => false
    t.column "user_id",      :integer,                 :default => 0
    t.column "aktion",       :string,    :limit => 40, :default => "unbekannt",           :null => false
    t.column "kommentar",    :text
  end

  create_table "pakets", :force => true do |t|
    t.column "lock_version",     :integer,   :default => 0,                     :null => false
    t.column "updated_at",       :timestamp,                                    :null => false
    t.column "updater_id",       :integer,   :default => 1
    t.column "created_at",       :timestamp, :default => '2004-01-01 10:10:10', :null => false
    t.column "name",             :string
    t.column "art",              :string
    t.column "status",           :integer,   :default => 1,                     :null => false
    t.column "hinweise",         :text
    t.column "hinweise_ausleih", :text
    t.column "ausleihbefugnis",  :integer,   :default => 0,                     :null => false
    t.column "geraetepark_id",   :integer,   :default => 0,                     :null => false
  end

  create_table "pakets_reservations", :id => false, :force => true do |t|
    t.column "lock_version",   :integer,   :default => 0,                     :null => false
    t.column "updated_at",     :timestamp,                                    :null => false
    t.column "created_at",     :timestamp, :default => '2004-01-01 10:10:10', :null => false
    t.column "paket_id",       :integer,   :default => 0
    t.column "reservation_id", :integer,   :default => 0
  end

  add_index "pakets_reservations", ["paket_id"], :name => "paket_id"
  add_index "pakets_reservations", ["reservation_id"], :name => "reservation_id"

  create_table "reservations", :force => true do |t|
    t.column "lock_version",     :integer,   :default => 0,                     :null => false
    t.column "updated_at",       :timestamp,                                    :null => false
    t.column "updater_id",       :integer,   :default => 1,                     :null => false
    t.column "created_at",       :timestamp, :default => '2004-01-01 10:10:10', :null => false
    t.column "status",           :integer,   :default => 0
    t.column "startdatum",       :datetime,  :default => '2005-10-01 10:00:00'
    t.column "enddatum",         :datetime,  :default => '2005-10-01 10:00:00'
    t.column "prioritaet",       :integer
    t.column "geraetepark_id",   :integer,   :default => 1,                     :null => false
    t.column "user_id",          :integer
    t.column "zweck",            :text
    t.column "hinweise",         :text
    t.column "herausgeber_id",   :integer
    t.column "rueckgabedatum",   :datetime
    t.column "zuruecknehmer_id", :integer
    t.column "bewertung",        :integer,   :default => 1,                     :null => false
  end

  add_index "reservations", ["status"], :name => "status"
  add_index "reservations", ["startdatum"], :name => "startdatum"

  create_table "sehers", :force => true do |t|
  end

  create_table "users", :force => true do |t|
    t.column "lock_version",  :integer,                  :default => 0,                     :null => false
    t.column "updated_at",    :timestamp,                                                   :null => false
    t.column "updater_id",    :integer,                  :default => 1
    t.column "created_at",    :timestamp,                :default => '2004-01-01 10:10:10', :null => false
    t.column "login",         :string,    :limit => 80
    t.column "password",      :string,    :limit => 40
    t.column "vorname",       :string,    :limit => 40
    t.column "nachname",      :string,    :limit => 80
    t.column "abteilung",     :string,    :limit => 20
    t.column "ausweis",       :string,    :limit => 40
    t.column "telefon",       :string,    :limit => 20
    t.column "email",         :string,    :limit => 200
    t.column "postadresse",   :text
    t.column "benutzerstufe", :integer,                  :default => 1,                     :null => false
    t.column "login_als",     :integer,                  :default => 0,                     :null => false
  end

  create_table "zeitmessung_nachher", :id => false, :force => true do |t|
    t.column "datum",  :binary,  :limit => 10, :default => "",          :null => false
    t.column "anzahl", :integer, :limit => 21, :default => 0,           :null => false
    t.column "aktion", :string,  :limit => 40, :default => "unbekannt", :null => false
    t.column "zeit",   :float,   :limit => 19
  end

  create_table "zeitmessung_nachher_lang", :id => false, :force => true do |t|
    t.column "anzahl", :integer, :limit => 21, :default => 0,           :null => false
    t.column "aktion", :string,  :limit => 40, :default => "unbekannt", :null => false
    t.column "zeit",   :float,   :limit => 19
  end

  create_table "zeitmessung_vorher", :id => false, :force => true do |t|
    t.column "datum",  :binary,  :limit => 10, :default => "",          :null => false
    t.column "anzahl", :integer, :limit => 21, :default => 0,           :null => false
    t.column "aktion", :string,  :limit => 40, :default => "unbekannt", :null => false
    t.column "zeit",   :float,   :limit => 19
  end

  create_table "zeitmessung_vorher_lang", :id => false, :force => true do |t|
    t.column "anzahl", :integer, :limit => 21, :default => 0,           :null => false
    t.column "aktion", :string,  :limit => 40, :default => "unbekannt", :null => false
    t.column "zeit",   :float,   :limit => 19
  end

  create_table "zubehoer", :force => true do |t|
    t.column "lock_version",   :integer,  :default => 0,                     :null => false
    t.column "updated_at",     :datetime,                                    :null => false
    t.column "created_at",     :datetime, :default => '2004-01-01 10:10:10', :null => false
    t.column "reservation_id", :integer,                                     :null => false
    t.column "beschreibung",   :string,   :default => "",                    :null => false
    t.column "anzahl",         :integer,  :default => 1,                     :null => false
  end

  add_index "zubehoer", ["reservation_id"], :name => "index_zubehoer_on_reservation_id"

end
