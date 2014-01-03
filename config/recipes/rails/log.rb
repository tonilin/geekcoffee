
namespace :rails do
  desc "tail production logs"
  task :log , :roles => :app, :except => { :no_release => true } do
    puts  "=======================   Tailing Logs ================== "
    trap("INT") { puts 'Interupted'; exit 0; }
    run "tail -f #{shared_path}/log/unicorn.stdout.log" do |channel, stream, data|
      puts  # for an extra line break before the host name
      puts "#{channel[:host]}: #{data}"
      break if stream == :err
    end
  end
end