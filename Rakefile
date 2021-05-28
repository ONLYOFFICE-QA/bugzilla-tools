# frozen_string_literal: true

desc 'Check backup restore in docker'
task :check_restore do
  image_name = 'bugzilla-backup-restore-check'
  local_backup_pattern = './bugzilla-backup*.tar.gz'

  sh("docker stop #{image_name} || true")
  sh("docker rm #{image_name} || true")
  sh("docker rmi #{image_name} || true")

  sh("docker build . --tag #{image_name}")
  sh("docker run --name #{image_name} -itd -p 80:80 #{image_name} bash")
  sh("docker cp #{local_backup_pattern} #{image_name}:/tmp") unless Dir.glob(local_backup_pattern).empty?
  sh("docker exec -it #{image_name} bash /root/restore-backup.sh")
end
