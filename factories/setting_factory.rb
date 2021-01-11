# coding: UTF-8

FactoryGirl.define do

  factory :setting do
    local_currency_string { 'CHF' }
    contract_terms do
      'Die Benutzerin/der Benutzer ist bei unsachgemässer Handhabung oder ' \
      'Verlust schadenersatzpflichtig. Sie/Er verpflichtet sich, das Material ' \
      'sorgfältig zu behandeln und gereinigt zu retournieren. Bei ' \
      'mangelbehafteter oder verspäteter Rückgabe kann eine Ausleihsperre ' \
      '(bis zu 6 Monaten) verhängt werden. Das geliehene Material bleibt ' \
      'jederzeit uneingeschränktes Eigentum der Zürcher Hochschule der Künste ' \
      'und darf ausschliesslich für schulische Zwecke eingesetzt werden. ' \
      'Mit ihrer/seiner Unterschrift akzeptiert die Benutzerin/der Benutzer ' \
      "diese Bedingungen sowie die 'Richtlinie zur Ausleihe von Sachen' der " \
      'ZHdK und etwaige abteilungsspezifische Ausleih-Richtlinien.'
    end
    contract_lending_party_string { "Your\nAddress\nHere" }
    email_signature { 'Das PZ-leihs Team' }
    default_email { 'sender@example.com' }
    deliver_received_order_notifications { false }
    user_image_url do
      'http://www.zhdk.ch/?person/foto&width=100&compressionlevel=0&id={:id}'
    end
    logo_url { '/assets/image-logo-zhdk.png' }
    disable_manage_section { false }
    disable_manage_section_message { '' }
    disable_borrow_section { false }
    disable_borrow_section_message { '' }
  end

end
