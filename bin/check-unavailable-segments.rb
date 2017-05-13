#!/usr/bin/env ruby
#  encoding: UTF-8
#
#  check-unavailable-segments
#
# DESCRIPTION:
#   Check if Druid has unavailable segments.
#
#   Unavailable segments could indicate an issue with any Historical node or Coordinator.
#   This check requests "loadstatus" from Coordinator API.
#   Druid responds with JSON, which contain information regarding segments to load for each datasource.
#
#   Druid documentation:
#   http://druid.io/docs/latest/design/coordinator.html
#
# PLATFORMS:
#   All
#
# DEPENDENCIES:
#   gem: sensu-plugin
#
# USAGE:
#  Check if amount of segments to load is not exceeding the threshold.
#  ./check-unavailable-segments.rb # Equivalent to examples below
#  ./check-unavailable-segments.rb -s localhost -p 8081 -c 0
#  ./check-unavailable-segments.rb --server localhost --port 8081 --critical 0
#
# LICENCE:
#   Yurii Rochniak <yrochnyak@gmail.com>
#   Released under the same terms as Sensu (the MIT license); see LICENSE
#   for details.
#

require 'sensu-plugin/check/cli'
require 'net/http'
require 'json'

class CheckUnavailableSegments < Sensu::Plugin::Check::CLI
  option :server,
         description: 'Druid Coordinator node to connect to.',
         short: '-s HOSTNAME',
         long: '--server HOSTNAME',
         default: 'localhost'

  option :port,
         description: 'Druid Coordinator API port.',
         short: '-p PORT',
         long: '--port PORT',
         default: '8081'

  option :critical,
         description: 'Maximum amount of segments to load for each datasource.',
         short: '-c CRITICAL',
         long: '--critical CRITICAL',
         proc: proc(&:to_i),
         default: 0

  def run
    api = '/druid/coordinator/v1/loadstatus?simple'
    issues = {}

    begin
      url = "http://#{config[:server]}:#{config[:port]}#{api}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
    rescue
      critical %(Cannot connect to the Coordinator host on http://#{config[:server]}:#{config[:port]}#{api})
    end

    parsed = JSON.parse(response)
    parsed.each do |datasource, segments|
      issues[datasource] = segments if segments.to_i > config[:critical]
    end

    ok %(Amount of segments to load  for each datasource is not greater than #{config[:critical]}) if issues.empty?
    critical %(Druid has datasources with more than #{config[:critical]} segments to load: #{issues.to_json})
  end
end
