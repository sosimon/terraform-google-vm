# Copyright 2018 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

project_id = attribute('project_id')
credentials_path = attribute('credentials_path')
region     = attribute('region')

ENV['CLOUDSDK_AUTH_CREDENTIAL_FILE_OVERRIDE'] = File.absolute_path(
  credentials_path,
  File.join(__dir__, "../../../fixtures/mig/autoscaler"))

expected_instances = 4
expected_instance_groups = 1

control "MIG" do
  title "Autoscaling Configuration"

  describe google_compute_region_instance_group_manager(project: project_id, region: 'us-central1', name: "mig-autoscaler-mig") do
    it { should exist }
    its('target_size') { should eq 4 }
    # TODO: add check 'autoscaled' == "yes"
    # TODO: add check 'autoscaler'.'autoscalingPolicy'.'cpuUtilization'.'utilizationTarget' == 0.6
  end

  describe google_compute_instances(project: project_id, zone: "us-central1-a") do
    it { should exist }
    its('count') { should eq 1 }
  end

  describe google_compute_instances(project: project_id, zone: "us-central1-a") do
    its('tag_count') { should eq 2 }
  end

  describe google_compute_instances(project: project_id, zone: "us-central1-a") do
    its('label_keys') { should include "environment" }
  end

  describe google_compute_instances(project: project_id, zone: "us-central1-a").label_value_by_key("environment") do
    it { should eq 'dev' }
  end

end
