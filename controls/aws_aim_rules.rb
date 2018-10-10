#
# Copyright 2015, Hecber Cordova
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# author: Hecber Cordova

control 'aws-1.2' do
    impact 1.0
    title 'Ensure MFA for all IAM users'
    desc "Ensure multi-factor authentication (MFA) is enabled for all IAM users that have a password"
    console_users_without_mfa = aws_iam_users
                            .where(has_console_password?: true)
                            .where(has_mfa_enabled?: false)
    describe console_users_without_mfa do
        it { should_not exist }
    end
end

control 'aws-1.2-a' do
    impact 1.0
    title 'Ensure MFA for all IAM users (root)'
    desc "Ensure multi-factor authentication (MFA) is enabled for root user"
    describe aws_iam_root_user do
        it { should have_mfa_enabled }
    end
end

control 'aws-1.3' do
    impact 1.0
    title 'Unused credentials'
    desc "Ensure credentials unused for 90 days or greater are disabled (Scored)"
    describe aws_iam_access_keys.where { created_days_ago > 90 } do
        it { should_not exist }
    end
end
