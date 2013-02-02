#!/usr/bin/ruby
# -*- coding: utf-8 -*-

$VERBOSE = true

RE_WITH_DATE = /^\d\d\d\d-\d\d-\d\d-/

DATE_FORMAT = '%Y-%m-%d-'

change_date_part = -> date_part, path {
  dir = File.dirname path
  base = File.basename path

  match = RE_WITH_DATE.match base
  no_date = if match.nil? then base else match.post_match end

  File.join( dir, date_part + no_date )
}.curry

if File.basename( $PROGRAM_NAME ) == 'rspec'

  describe DATE_FORMAT do
    subject { Time.local( 2013, 1, 31 ).strftime DATE_FORMAT }
    it { should eql '2013-01-31-' }
  end

  describe :change_date_part do

    context 'when a path without date given,' do
      it 'returns the path with the date and relative path' do
        change_date_part[ '1989-04-16-', 'my-birthday.mkd' ] \
          .should eql( './1989-04-16-my-birthday.mkd' )

        change_date_part[ '2000-03-03-', 'articles/hinamatsuri.mkd' ] \
          .should eql( 'articles/2000-03-03-hinamatsuri.mkd' )
      end
    end

    context 'when a path with a date given,' do
      before { @today = Time.now.strftime( DATE_FORMAT ) }
      subject { change_date_part[ @today ] }

      it 'returns the path with the date and relative path' do
        subject[ 'today.mkd' ]
          .should eql( "./#{@today}today.mkd" )

        subject[ 'articles/a-day.mkd' ] \
          .should eql( "articles/#{@today}a-day.mkd" )
      end
    end

  end

else
  # executing
  require 'fileutils'

  update_date = change_date_part[ Time.now.strftime DATE_FORMAT ]
  ARGV.map( &update_date ).zip( ARGV ) do|dest, src|
    system( *%W/git mv --verbose #{src} #{dest}/ )
  end
end
