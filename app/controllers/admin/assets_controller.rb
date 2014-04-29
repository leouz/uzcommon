# -*- encoding : utf-8 -*-
class Admin::AssetsController < AdminControllerBase
  def index    
  end

  def get group=nil
    if group      
      assets = Asset.where(group: group).order("created_at DESC").all
    else
      assets = Asset.order("created_at DESC").all
    end
    render :json => assets
  end

  def summernote_upload       
    asset = Asset.new
    asset.file = params[:file]
    if asset.save    
      render :json => { :id => asset.id, :url => asset.file_url, :thumb => asset.file_url(:thumb) }
    else
      render :json => { :erros => asset.errors.full_messages.join(', ').html_safe }, :status => 404
    end
  end

  def create    
    params[:asset][:file] = params[:asset][:file].first
    file = params[:asset][:file]
    asset = Asset.new(params[:asset])    
    if asset.save          
      render :json => { :id => asset.id, :url => asset.file.url, :thumb => asset.file_url(:thumb), :file => file }
    else
      render :json => { :erros => asset.errors.full_messages.join(', ').html_safe }, :status => 404
    end
  end

  def destroy
    params[:assets].each do |p|
      Asset.find(p).destroy
    end
    render :nothing => true
  end
end
