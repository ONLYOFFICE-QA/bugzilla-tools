# frozen_string_literal: true

desc 'Check backup in docker'
task :check_backup_in_docker do
  image_name = 'bugzilla-backup-restore-check'
  local_backup_pattern = './bugzilla-backup*.tag.gz'
  sh("docker build . --tag #{image_name}")
  sh("docker run --name #{image_name} -itd -p 80:80 #{image_name} bash")
  sh("docker cp #{local_backup_pattern}:#{image_name}:/tmp") unless Dir.glob(local_backup_pattern).empty?
  sh("docker exec -it #{image_name} /root/restore-backup.sh")
end
