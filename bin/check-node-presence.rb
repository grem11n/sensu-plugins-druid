#!/usr/bin/env ruby
#  encoding: UTF-8
#
#  check-node-presence
#
# DESCRIPTION:
#   Check if Druid Historical node is present in Coordinator UI.
#
#   This script checks Server status in Coordinator UI.
#   IN general, there should be a list of Historical nodes for
#   different tiers.
#   This check requests "servers" from Coordinator API.
#   Druid responds with JSON, which contains information about
#   Historical servers status.
#
#   Druid documentation:
#   http://druid.io/docs/latest/design/coordinator.html
#
# PLATFORMS:
#   All
#
# DEPENDENCIES:
#   gem: sensu-plugin
#   gem: json
#
# USAGE:
#  Check if amount of segments to load is not exceeding the threshold.
#  ./check-node-presence.rb -s localhost -p 8081 -n historical-node01
#  ./check-node-presence.rb --server localhost --port 8081 --node historical-node01
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

  option :node,
         description: 'Node pattern to search',
         short: '-n NODE',
         long: '--node NODE',
         proc: proc(&:to_s)

  def run
    api = '/druid/coordinator/v1/servers?simple'

    begin
      url = "http://#{config[:server]}:#{config[:port]}#{api}"
      uri = URI(url)
      response = Net::HTTP.get(uri)
    rescue
      critical %(Cannot connect to the Coordinator host on http://#{config[:server]}:#{config[:port]}#{api})
    end

    parsed = JSON.parse(response)
    parsed.each do |node|
      if node['host'] =~ /#{config[:node]}/
        ok %(Found #{node['type']} #{node['host']}, which is like #{config[:node]})
      end
    end
    critical %("Node matching #{config[:node]} not found in Coordinator server list!")
  end
end
