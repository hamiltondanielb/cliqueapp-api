namespace :uploads do
  desc 'Re-process images from all posts'
  task :reprocess => :environment do
    Post.all.each {|p|
      puts "Processing post id # #{p.id}"
      p.media.reprocess!
    }
  end
end
