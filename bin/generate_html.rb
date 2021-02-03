#!/usr/bin/env ruby
require "date"
require "erb"
require "json"

class Template
    attr_accessor :hours
    attr_accessor :minutes
    attr_accessor :total_deaths
    attr_accessor :date

    def delimited_number(number)
        sprintf("%d", number).gsub(/(\d)(?=\d{3}+$)/, '\1,')
    end

    def render
        template = File.read("index.html.erb")
        renderer = ERB.new(template)
        renderer.result(binding)
    end
end

# Sum all regional deaths
deaths = Dir["data/*.json"].map do |file|
    data = JSON.parse(File.read(file))
    latest_deaths = data["body"][0]["cumDeathsByPublishDate"]
end.sum

# Calculate how long you'd have to clap
seconds = deaths / 2.0
hours = (seconds / 60 / 60).to_i
minutes = (60 * ((seconds / 60 / 60) - hours)).to_i


# Build a template
template = Template.new
template.hours = hours
template.minutes = minutes
template.total_deaths = deaths
template.date = Date.today

output = template.render
File.write("dist/index.html", output)