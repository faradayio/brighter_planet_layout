require 'fileutils'
require 'yaml'

module BrighterPlanetLayout
  GEM_ROOT = File.expand_path File.join(File.dirname(__FILE__), '..')
  VERSION = YAML.load File.read(File.join(GEM_ROOT, 'VERSION'))
  
  def self.view_path
    File.join GEM_ROOT, 'app', 'views'
  end
  
  def self.helper_file
    File.join GEM_ROOT, 'app', 'helpers', 'brighter_planet_helper.rb'
  end
  
  def self.layout_warning_file
    File.join Rails.root, 'public', "BRIGHTER_PLANET_LAYOUT_VERSION_#{VERSION}"
  end
  
  def self.public_path
    File.join GEM_ROOT, 'public'
  end
  
  def self.copy_static_files_to_web_server_document_root
    Dir[File.join(public_path, '*')].each do |source_path|
      dest_path = File.join(Rails.root, 'public', source_path.gsub(public_path, ''))
      if File.directory? source_path
        FileUtils.cp_r source_path.concat('/.'), dest_path
      else
        FileUtils.cp source_path, dest_path
      end
    end
    install_layout_warning
  end
  
  def self.install_layout_warning
    FileUtils.touch layout_warning_file
  end
  
  def self.layout_warning_installed?
    File.readable? layout_warning_file
  end
  
  def self.copy_static_files?
    not serve_static_files_using_rack? and not layout_warning_installed?
  end
  
  def self.serve_static_files_using_rack?
    Rails.configuration.serve_static_assets or not Rails.env.production?
  end
end

require 'brighter_planet_layout/railtie'
