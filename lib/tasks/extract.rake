task :extract_companies => :environment do

  print "Extracting companies"

  companies = Company.all

  array = []

  companies.each do |company|
    hash = {}

    if company
      hash[:company_linkedin_id] = company.company_linkedin_id ? company.company_linkedin_id : 0
      hash[:company_linkedin_name] = company.company_linkedin_name ? company.company_linkedin_name : "non existant"

    array << hash
    end

    print "."
  end

  string = YAML.dump(array)
  outfile = File.new("hash_of_companies.yml", "w")
  outfile.write(string)
  outfile.close
  
  print "Extracting companies completed"
end

task :unpack_companies => :environment do

  print "Unpacking companies"

  yaml = File.read("hash_of_companies.yml")
  companies = YAML.load(yaml)

  companies.each do |company|
    if company
      Company.create(company)
    end

    print "."
  end

  print "Unpacking companies completed"
end