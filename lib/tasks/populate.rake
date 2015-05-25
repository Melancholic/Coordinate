namespace :db do
  desc "Fill database with firsts users"
  task populate: :environment do
     make_users();
  end
end


def make_users(size=9000)
    File.open(File.join("log/", 'users.log'), 'a+') do |f|
      size.times do |n|
        usr=User.new;
        begin
          usr=User.new;
          tmp=Bazaar.heroku;
          usr.login=Faker::Name.name.split()[0];
          tmp=Bazaar.heroku;
          usr.password_confirmation=usr.password=tmp.split('-')[1]
          usr.email=usr.login+"@mail.com";
          usr.created_at= Rand.time(Time.now.utc.beginning_of_year, Time.now.utc.beginning_of_year+1.year)
          #puts "uncorrect: #{usr.name}  #{usr.email}  #{usr.password}"
        end while (!usr.valid?)
        f.puts("#{usr.name}  #{usr.email}  #{usr.password}");
        puts "\tCorrect: #{usr.name}  #{usr.email}  #{usr.password}"
        usr.save();
        usr.verification_user.update(verification_key:"",verificated:true);
        #usr.verification_user=VerificationUser.create(user_id: usr.id, verificated:true);
      end
    end
end
