# -*- encoding : utf-8 -*-

Angenommen /^ich bin (.*?)$/ do |persona_name|
  step "I am %s" % persona_name
end

Wenn /^ich eine Rücknahme mache$/ do
  step 'I open a take back'
end

Wenn /^einem Gegenstand einen Inventarcode manuell zuweise$/ do
  step 'I click an inventory code input field of an item line'
  step 'I select one of those'
end

Wenn /^ich versuche, die Gegenstände auszuhändigen$/ do
  step 'I click hand over'
end

Wenn /^ich eine Aushändigung mache$/ do
  step 'I open a hand over which has multiple unassigned lines and models in stock'
end

Dann /^findet man die Benutzeradministration im Bereich "Administration" unter "Benutzer"$/ do
  step 'I follow "Admin"'
  step 'I follow "%s"' % _("Users")
end

Wenn(/^ich einen Gegenstand zurücknehme$/) do
  step 'I open a take back'
  step 'I select all lines of an open contract'
  step 'I click take back'
  step 'I see a summary of the things I selected for take back'
  step 'I click take back inside the dialog'
  step 'the contract is closed and all items are returned'
end

Wenn /^ich eine Bestellung bearbeite$/ do
  step 'I open a contract for acknowledgement'
end

Angenommen /^man öffnet einen Vertrag bei der Rücknahme/ do
  step 'I open a take back'
  step 'I select all lines of an open contract'
  step 'I click take back'
  step 'I click take back inside the dialog'
end

Wenn /^einige der ausgewählten Gegenstände hat keinen Zweck angegeben$/ do
  step 'I click an inventory code input field of an item line'
  step 'I select one of those'
  step 'I add an item to the hand over by providing an inventory code'
  step 'I add an option to the hand over by providing an inventory code and a date range'
end

Dann(/^kann man als "(.+)" keine, eine oder mehrere der folgenden Möglichkeiten in Form einer Checkbox auswählen:$/) do |arg, table|
  step %Q(one is able to choose for "#{arg}" none, one or more of the following options if form of a checkbox:), table
end

Wenn(/^ich als Betriebssystem keine, eine oder mehrere der vorhandenen Möglichkeiten auswähle$/) do
  step %Q(if I choose none, one or more of the available options for operating system)
end

Wenn(/^ich als Installation keine, eine oder mehrere der vorhandenen Möglichkeiten auswähle$/) do
  step %Q(if I choose none, one or more of the available options for installation)
end

Wenn(/^ich die Optionen für das Betriebssystem ändere$/) do
  step %Q(I change the options for operating system)
end

Wenn(/^ich die Optionen für die Installation ändere$/) do
  step %Q(I change the options for installation)
end

Angenommen(/^ein Modell existiert, welches keine Version hat$/) do
  step "there is a model without a version"
end

Wenn(/^ich dieses Modell dem Gegestand zuweise$/) do
  step "I assign this model to the item"
end

Dann(/^steht in dem Modellfeld nur der Produktname dieses Modell$/) do
  step "there is only product name in the input field of the model"
end

Dann(/^kann man als "(.*?)" einen der folgenden Möglichkeiten anhand eines Radio\-Buttons wählen:$/) do |arg1, table|
  step %Q(for "#{arg1}" one can select one of the following options with the help of radio button), table
end

Dann(/^kann man als "(.*?)" ein Datum auswählen$/) do |arg1|
  step %Q(for "#{arg1}" one can select a date)
end

Dann(/^die mögliche Werte für Maintenance\-Vertrag sind in der folgenden Reihenfolge:$/) do |table|
  step "for maintenance contract the available options are in the following order:", table
end

Dann(/^kann man als "(.*?)" eine Zahl eingeben$/) do |arg1|
  step %Q(for "#{arg1}" one can enter a number)
end

Dann(/^kann man als "(.*?)" einen Text eingeben$/) do |arg1|
  step %Q(for "#{arg1}" one can enter some text)
end

Dann(/^kann man als "(.*?)" einen Lieferanten auswählen$/) do |arg1|
  step %Q(for "#{arg1}" one can select a supplier)
end

Dann(/^kann man als "(.*?)" einen Gerätepark auswählen$/) do |arg1|
  step %Q(for "#{arg1}" one can select an inventory pool)
end

Wenn(/^ich als Lizenzablaufdatum ein Datum auswähle$/) do
  step %Q(I choose a date for license expiration)
end

Wenn(/^ich als Maintenance\-Vertrag "(.*?)" auswähle$/) do |arg1|
  step %Q(I choose "#{arg1}" for maintenance contract)
end

Dann(/^kann ich für den Maintenance\-Vertrag kein Ablaufdatum wählen$/) do
  step %Q(I am not able to choose the maintenance expiration date)
end

Wenn(/^ich für den Maintenance\-Vertrag ein Ablaufdatum wähle$/) do
  step %Q(I choose a date for the maintenance expiration)
end

Wenn(/^ich als Bezug "(.*?)" wähle$/) do |arg1|
  step %Q(I choose "#{arg1}" as reference)
end

Dann(/^muss ich eine Projektnummer eingeben$/) do
  step %Q(I have to enter a project number)
end

Wenn(/^ich das Lizenzablaufdatum ändere$/) do
  step %Q(I change the license expiration date)
end

Wenn(/^ich den Wert für den Maintenance\-Vertrag ändere$/) do
  step %Q(I change the value for maintenance contract)
end

Wenn(/^ich den Wert für Bezug ändere$/) do
  step %Q(I change the value for reference)
end

Wenn(/^ich der Aushändigung ein Gegenstand mit Hilfe eines Inventarcodes hinzufüge$/) do
  step %Q(I add an item to the hand over by providing an inventory code)
end

Wenn(/^ich der Aushändigung eine Lizenz mit Hilfe eines Inventarcodes hinzufüge$/) do
  step %Q(I add an license to the hand over by providing an inventory code)
end

Dann(/^wurde diese Aushändigung erfolgreich abgeschlossen$/) do
  step %Q(this hand over was completed successfully)
end

Wenn(/^ich die notwendigen Angaben im Aushändigungsdialog mache$/) do
  step %Q(I fill in all the necessary information in hand over dialog)
end

Dann(/^sind im Vertrag sowohl der Gegenstand als auch die Lizenz aufgeführt$/) do
  step %Q(there are inventory codes for item and license in the contract)
end

Angenommen(/^es existieren Software\-Produkte$/) do
  step "a software product exists"
end

Angenommen(/^es existiert eine Software\-Lizenz$/) do
  step "a software license exists"
end

Angenommen(/^es existiert ein Software\-Produkt mit folgenden Eigenschaften:$/) do |table|
  step "there is a software product with the following properties:", table
end

Angenommen(/^es existiert eine Software\-Lizenz mit folgenden Eigenschaften:$/) do |table|
  step "there is a software license with the following properties:", table
end

Wenn(/^ich nach einer dieser Software\-Produkt Eigenschaften suche$/) do
  step "I search after one of those software product properties"
end

Wenn(/^ich nach einer dieser Software\-Lizenz Eigenschaften suche$/) do
  step "I search after one of those software license properties"
end

Dann(/^es erscheinen alle zutreffenden Software\-Produkte$/) do
  step "they appear all matched software products"
end

Dann(/^es erscheinen alle zutreffenden Software\-Lizenzen$/) do
  step "they appear all matched software licenses"
end

Dann(/^es erscheinen alle zutreffenden Verträge, in denen diese Software\-Produkt vorkommt$/) do
  step "they appear all matched contracts, in which this software product is contained"
end

Angenommen(/^diese Software\-Lizenz ist an jemanden ausgeliehen$/) do
  step "this software license is handed over to somebody"
end

Wenn(/^ich nach dem Namen dieser Person suche$/) do
  step "I search after the name of that person"
end

Dann(/^erscheint der Vertrag dieser Person in den Suchresultaten$/) do
  step "it appears the contract of this person in the search results"
end

Dann(/^es erscheint diese Person in den Suchresultaten$/) do
  step "it appears this person in the search results"
end

Angenommen(/^es existieren für diese Produkte Software\-Lizenzen$/) do
  step "there exist licenses for this software product"
end

Wenn(/^ich diese in meinen Suchresultaten sehe$/) do
  step "I see these in my search result"
end

Dann(/^kann ich wählen, ausschliesslich Software\-Produkte aufzulisten$/) do
  step "I can select to list only software products"
end

Dann(/^ich kann wählen, ausschliesslich Software\-Lizenzen aufzulisten$/) do
  step "I can select to list only software licenses"
end

Wenn(/^ich dieses Software\-Produkt aus der Liste lösche$/) do
  step "I delete this software product from the list"
end

Dann(/^das Software\-Produkt wurde aus der Liste gelöscht$/) do
  step "the software product is deleted from the list"
end

Dann(/^das Software\-Produkt ist gelöscht$/) do
  step "the software product is deleted"
end

Wenn(/^ich alle Pflichtfelder für die Lizenz ausfülle$/) do
  step "I fill in all the required fields for the license"
end

Wenn(/^ich die Software setze$/) do
  step "I fill in the software"
end

Wenn(/^ich im Feld "(.*?)" den Wert "(.*?)" eingebe$/) do |field, value|
  step %Q(I fill in the field "#{field}" with the value "#{value}")
end

Dann(/^ist der "(.*?)" mit zwei Dezimalstellen gespeichert$/) do |field|
  step %Q("#{field}" is saved with two decimal digits)
end

Wenn(/^ich eine Software\-Lizenz mit gesetztem Maintenance\-Ablaufdatum, Lizenzablaufdatum und Rechnungsdatum editiere$/) do
  step %Q(I edit a license with set dates for maintenance expiration, license expiration and invoice date)
end

Wenn(/^ich die Daten für die folgenden Feldern lösche:$/) do |table|
  step %Q(I delete the data for the following fields:), table
end

Wenn(/^sind die folgenden Felder der Lizenz leer:$/) do |table|
  step %Q(the following fields of the license are empty:), table
end

Wenn(/^ich die gleiche Lizenz editiere$/) do
  step %Q(I edit the same license)
end

Wenn(/^ich für den Gerätepark die automatische Sperrung von Benutzern mit verspäteter Rückgaben einschalte$/) do
  step "on the inventory pool I enable the automatic suspension for users with overdue take backs"
end

Wenn(/^ein Benutzer bereits gesperrt ist$/) do
  step "a user is already suspended for this inventory pool"
end

Dann(/^werden der bestehende Sperrgrund sowie die Sperrzeit dieses Benutzers nicht überschrieben$/) do
  step "the existing suspension motivation and the suspended time for this user are not overwritten"
end

Angenommen(/^ich befinde mich in einer Rücknahme mit mindestens einem Gegenstand und einer Option$/) do
  step "I open a take back with at least one item and one option"
end

Wenn(/^ich bei der Option eine Stückzahl von (\d+) eingebe$/) do |n|
  step "I set a quantity of #{n} for the option line"
end

Wenn(/^beim Gegenstand eine Inspektion durchführe$/) do
  step "I inspect an item"
end

Wenn(/^ich setze "(.*?)" auf "(.*?)"$/) do |arg1, arg2|
  step %Q(I set "#{arg1}" to "#{arg2}")
end

Dann(/^steht bei der Option die zuvor angegebene Stückzahl$/) do
  step %Q(the option line has still the same quantity)
end

Wenn(/^ich die Anzahl "(.*?)" in das Mengenfeld schreibe$/) do |arg1|
  step "I change the quantity to \"%s\"" % arg1
end

Dann(/^wird die Menge mit dem ursprünglichen Wert überschrieben$/) do
  step "the quantity will be restored to the original value"
end

Dann(/^wird die Menge mit dem Wert "(.*?)" gespeichert$/) do |arg1|
  step "the quantity will be stored to the value \"%s\"" % arg1
end

Wenn(/^ich das Software\-Produkt wieder editiere$/) do
  step "I edit again this software product"
end

Dann(/^werden nur die Linien mit Links zusätzlich ausserhalb des Textfeldes angezeigt$/) do
  step "outside the the text field, they will additionally displayed lines with link only"
end

Angenommen(/^ich befinde mich in der Software\-Inventar\-Übersicht$/) do
  step "I'am on the software inventory overview"
end

Wenn(/^ich den CSV\-Export anwähle$/) do
  step "I press CSV-Export"
end

Dann(/^werden alle Lizenz\-Zeilen, wie gerade gemäss Filter angezeigt, exportiert$/) do
  step "all filtered software licenses will be exported"
end

Dann(/^die Zeilen enthalten alle Lizenz\-Felder$/) do
  step "the lines contain all license fields"
end

Angenommen /^ich erstelle eine? neues? (?:.+) oder ich ändere eine? bestehendes? (.+)$/ do |entity|
  step "ich add a new #{entity} or I change an existing #{entity}"
end

Wenn(/^ich dieses? "(.+)" aus der Liste lösche$/) do |entity|
  step %Q(I delete this #{entity} from the list)
end

Dann(/^(?:die|das) "(.+)" ist gelöscht$/) do |entity|
  step %Q(the "#{entity}" is deleted)
end

Angenommen(/^man editiert das Feld "(.*?)" eines ausgeliehenen Gegenstandes, wo man Besitzer ist$/) do |arg1|
  step %Q(one edits the field "#{arg1}" of an owned item not in stock)
end

Dann(/^sehe ich die "Software Informationen" angezeigt$/) do
  step %Q(I see the "Software Information")
end

Wenn(/^ich eine bestehende Software\-Lizenz mit Software\-Informationen und Anhängen editiere$/) do
  step %Q(I edit an existing software license with software information and attachments)
end

Dann(/^die "Software Informationen" sind nicht editierbar$/) do
  step %Q(the software information is not editable)
end

Dann(/^die bestehende Links der "Software Informationen" öffnen beim Klicken in neuem Browser\-Tab$/) do
  step %Q(the links of software information open in a new tab upon clicking)
end

Dann(/^ich kann Modelle hinzufügen$/) do
  step "I can add models"
end

Dann(/^sehe ich die "Anhänge" der Software angezeigt$/) do
  step %Q(I see the attachments of the software)
end

Dann(/^ich kann die Anhänge in neuem Browser\-Tab öffnen$/) do
  step %Q(I can open the attachments in a new tab)
end

Wenn 'ich logge mich aus' do
  step "I make sure I am logged out"
end

Wenn(/^ich in das Zuteilungsfeld links vom Software\-Namen klicke$/) do
  step "I click on the assignment field of software names"
end

Dann(/^wird mir die Inventarnummer sowie die vollständige Seriennummer angezeigt$/) do
  step "I see the inventory codes and the complete serial numbers of that software"
end

Wenn(/^der Hersteller bereits existiert$/) do
  step %(there exists already a manufacturer)
end

Dann(/^kann der Hersteller aus der Liste ausgewählt werden$/) do
  step %Q(the manufacturer can be selected from the list)
end

Wenn(/^ich einen nicht existierenden Hersteller eingebe$/) do
  step %Q(I set a non existing manufacturer)
end

Dann(/^der neue Hersteller ist in der Herstellerliste auffindbar$/) do
  step %Q(the new manufacturer can be found in the manufacturer list)
end

Wenn(/^ich als Aktivierungsart Dongle wähle$/) do
  step %Q(I choose dongle as activation type)
end

Dann(/^muss ich eine Dongle\-ID eingeben$/) do
  step %Q(I have to provide a dongle id)
end

Wenn(/^ich einen der folgenden Lizenztypen wähle:$/) do |table|
  step %Q(I choose one of the following license types), table
end

Wenn(/^ich eine Anzahl eingebe$/) do
  step %Q(I fill in a value)
end

Angenommen(/^es gibt eine Software\-Lizenz$/) do
  step %Q(there exists a software license)
end

Wenn(/^ich diese Lizenz in der Softwareliste anschaue$/) do
  step %Q(I look at this license in the software list)
end

Angenommen(/^es gibt eine Software\-Lizenz mit einem der folgenden Typen:$/) do |table|
  step %Q(there exists a software license of one of the following types), table
end

Angenommen(/^es gibt eine Software\-Lizenz, wo meine Abteilung der Besitzer ist, die Verantwortung aber auf eine andere Abteilung abgetreten hat$/) do
  step %Q(there exists a software license, owned by my inventory pool, but given responsibility to another inventory pool)
end

Angenommen(/^es gibt eine Software\-Lizenz, die nicht an Lager ist und eine andere Abteilung für die Software\-Lizenz verantwortlich ist$/) do
  step %Q(there exists a software license, which is not in stock and another inventory pool is responsible for it)
end

Wenn(/^der Vertrag eine Software\-Lizenz beinhaltet$/) do
  step "the contract contains a software license"
end

Dann(/^sehe ich zusätzlich die folgende Information$/) do |table|
  step "I additionally see the following informatins", table
end

Angenommen(/^ich editiere eine Gerätepark( bei dem die aut. Zuweisung aktiviert ist)?$/) do |arg1|
  step "I edit an inventory pool%s" % (arg1 ? " which has the automatic access enabled" : nil)
end

Wenn(/^ich "(.*)" aktiviere$/) do |arg1|
  step %Q(I enable "%s") % arg1
end

Dann(/^ist "(.*)" aktiviert$/) do |arg1|
  step %Q("%s" is enabled) % arg1
end

Wenn(/^ich "(.*)" deaktiviere$/) do |arg1|
  step %Q(I disable "%s") % arg1
end

Dann(/^ist "(.*)" deaktiviert$/) do |arg1|
  step %Q("%s" is disabled) % arg1
end

Angenommen(/^eine Software\-Produkt mit mehr als (\d+) Zeilen Text im Feld "(.*?)" existiert$/) do |arg1, arg2|
  step %Q(a software product with more than %d text rows in field "%s" exists) % [arg1, arg2]
end

Wenn(/^ich diese Software editiere$/) do
  step "I edit this software"
end

Wenn(/^ich in das Feld "(.*?)" klicke$/) do |arg1|
  step %Q(I click in the field "%s") % arg1
end

Dann(/^wächst das Feld, bis es den ganzen Text anzeigt$/) do
  step "this field grows up till showing the complete text"
end

Wenn(/^ich aus dem Feld herausgehe$/) do
  step "I release the focus from this field"
end

Dann(/^schrumpft das Feld wieder auf die Ausgangsgrösse$/) do
  step "this field shrinks back to the original size"
end
