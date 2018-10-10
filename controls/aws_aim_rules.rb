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

control 'aws-1.3 / aws-1.4' do
    impact 1.0
    title 'Unused credentials / Rotate Credentials'
    desc "Ensure credentials unused for 90 days or greater are disabled (Scored)"
    describe aws_iam_access_keys.where { created_days_ago > 90 } do
        it { should_not exist }
    end
end

control 'aws-1.5 / aws-1.6 / aws-1.7 / aws-1.8 / aws-1.9 / aws-1.10 / aws-1.11' do
    impact 1.0
    title 'Password Complexity'
    desc "Ensure IAM password policy requires at least: one uppercase letter,
          one lowercase letter, one symbol, one number, minimum length of 14 or greater,
          prevents password reuse, expires passwords within 90 days or less"
    describe aws_iam_password_policy do
        it { should require_uppercase_characters }
        it { should require_lowercase_characters }
        it { should require_symbols }
        it { should require_numbers }
        its('minimum_password_length') { should be > 13 }
        it { should prevent_password_reuse }
        its('max_password_age_in_days') { should be 90 }
    end
end

control 'aws-1.13' do
    impact 1.0
    title 'Ensure MFA is enabled for the root account'
    desc "Ensure  MFA is enabled for the root account (Scored)"
    describe aws_iam_root_user do
        it { should have_mfa_enabled }
    end
end
