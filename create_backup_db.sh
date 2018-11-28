pwd
echo $HOME

HOME=. aptible login --email support@trialspark.com --password "$1" --lifetime "1 day"

backup_id=$(aptible backup:list spark-staging-1 | head -n 1 | awk \'{ print $1; }\' | sed \'s/:$//\')

backup_handle=$(date +"%Y%m%d%H%M%S")
backup_handle+="_spark-staging-1"

echo 'Restoring backup $backup_id to $backup_handle'
aptible backup:restore $backup_id --handle=$backup_handle
