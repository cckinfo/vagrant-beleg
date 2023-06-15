#!/bin/bash

# Extract user login data from auth.log
login_data=$(grep -a "session opened" /var/log/auth.log)
# Extract unique user names
unique_users=$(echo "$login_data" | awk '{print $11}' | sort -u)
# Initialize output variable
output=""
# Loop through each unique user
for user in $unique_users; do
  # Filter the login entries for the current user
  user_entries=$(echo "$login_data" | grep "session opened.*$user")

  # Count the number of logins for the current user
  total_logins=$(echo "$user_entries" | wc -l)

  # Extract the first and last login timestamps for the current user
  first_login=$(echo "$user_entries" | head -n 1 | awk '{print $1, $2, $3}')
  last_login=$(echo "$user_entries" | tail -n 1 | awk '{print $1, $2, $3}')
  # Calculate the time difference between first and last login for the current user
  time_diff=$(($(date -d "$last_login" +%s) - $(date -d "$first_login" +%s)))
  time_diff_formatted=$(date -u -d @$time_diff +%H:%M:%S)
  # Calculate the average login frequency for the current user
  avg_login_freq=$(bc <<< "scale=1; $time_diff / ($total_logins)")
  # Output the login information for the current user
  output+="User $user has number of logins $total_logins.\n"
  output+="First login of $user at $first_login.\n"
  output+="Last login of $user at $last_login.\n"
  output+="The time difference between first and last login was $time_diff_formatted.\n"
  output+="During the first and last login, the user logged in on average every $avg_login_freq seconds.\n"
  output+="--------------------------------------------\n"
done
echo -e "$output" > /home/vagrant/login_data.txt
