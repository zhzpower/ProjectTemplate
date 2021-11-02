require 'xcodeproj'
require 'optparse'
# ruby changeinfo.rb --name=com.zhz.ProjectTemplate

options = {}
OptionParser.new do |opt|
    opt.on('--name NAME') { |o| options[:name] = o }
end.parse!
projectName = options[:name]
puts "新bundleid: #{projectName}"
abort if projectName.nil?

project = Xcodeproj::Project.open("./ProjectTemplate/ProjectTemplate.xcodeproj")
# target build setting
project.targets.each do |target|
    target.build_configurations.each do |config|
        # puts config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"]
        config.build_settings["PRODUCT_BUNDLE_IDENTIFIER"] = projectName
    end
end

project.save

puts "#{projectName} 替换成功!!!"