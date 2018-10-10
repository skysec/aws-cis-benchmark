FROM ruby:2.5.1-stretch
RUN gem install inspec
CMD ["/bin/sh"]
