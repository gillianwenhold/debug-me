require_relative './song_library.rb'
require "pry"

def jukebox(command)
  if command.downcase == "list"
    list_library
  else
    parse_command(command)
  end
end

def list_library
  lib = full_library
  lib.each do |artist, album_hash|
    puts list_artist(artist, album_hash)
  end
end

def list_artist(artist, album_hash)
  puts "Artist: " + artist.to_s
  puts "Album hash: " + album_hash.to_s
   artist_list = "\n"
   album_hash[:albums].each do |album_name, songs_hash|
     artist_list += "\n#{album_name}:\n\t"
     artist_list += songs_hash[:songs].join("\n\t")
   end
   artist_list
end

def parse_command(command)
  if !parse_artist(command, full_library)
    if !play_song(command, full_library)
      not_found(command)
    end
  end
end

def parse_artist(command, lib)
  cmd = command.to_sym
  parsed = false
  if lib.has_key?(cmd)
    puts list_artist(cmd, lib[cmd])
    parsed = true
  else
    lib.each do |artist, hash|
      if command.downcase == artist.to_s.gsub("_"," ").downcase
        puts list_artist(artist, hash)
        parsed = true
        break
      end
    end
  end
  parsed
end

def play_song(command, lib)
  playing = false
  lib.each do |artist, hash|
    hash.each do |album_name, albums_hash|
      albums_hash.each do |album, songs_hash|
        songs_hash.each do |songs, songs_list|
          songs_list.each do |song|
            if song.downcase == command.downcase
              puts "Now Playing: #{artist}: #{album} - #{song}\n\n"
              playing = true
              break
            end
          end
        end
      end
    end
  end
  playing
end

def not_found(command)
  puts "I did not understand '#{command}'!\n\n"
  true
end

