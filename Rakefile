require 'html-proofer'

task :test do
    sh "bundle exec jekyll build"
    # sh "htmlproofer --allow-hash-href true _site/"
    HTMLProofer.check_directory("./_site", {
        :allow_hash_href => true,
        :assume_extension => [".html"],
        :disable_external => true
    }).run
end