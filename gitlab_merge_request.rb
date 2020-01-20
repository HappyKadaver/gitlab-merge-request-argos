#!/bin/env ruby
require 'gitlab'
require 'pathname'
require 'yaml'


module Argos
  class GitlabMergeRequest
    def initialize
      @config = YAML.load_file(Pathname.new(__dir__).join('secrets.yaml').to_s)['gitlab_merge_request']
      @project_id = @config['project_id']

      Gitlab.endpoint = 'https://gitlab.com/api/v4'
      Gitlab.private_token = @config['token']
      # user's private token or OAuth2 access token, default: ENV['GITLAB_API_PRIVATE_TOKEN']
    end

    def print_ui(merge_requests)
      puts 'MRs'
      puts '---'
      puts '--My Merge Requests'

      merge_requests.each do |merge_request|
        print_merge_request_item merge_request
      end
    end

    def print_merge_request_item(merge_request)
      puts "!#{merge_request.iid}"
    end

    def main
      my_merge_requests = Gitlab.merge_requests(@project_id)
      print_ui my_merge_requests
    end
  end
end

Argos::GitlabMergeRequest::new.main
