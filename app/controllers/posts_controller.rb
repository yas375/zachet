# -*- coding: utf-8 -*-
class PostsController < ApplicationController
  layout 'forum'
  before_filter :find_topic, :only => [:create, :edit, :update, :destroy]

  def create
    @post = @topic.posts.build(params[:post].merge(:author => current_user))

    if @post.save
      flash[:notice] = "Ответ создан"
      redirect_to @topic
    else
      render :action => 'new'
    end
  end

  def edit
    @post = @topic.posts.find(params[:id])
  end

  def update
    @post = @topic.posts.find(params[:id])

    if @post.update_attributes(params[:post].slice!(:author_id))
      flash[:notice] = "Ответ изменён"
      redirect_to @topic
    else
      render :action => 'edit'
    end
  end

  def destroy
    @post = @topic.posts.find(params[:id])

    @post.destroy
    flash[:notice] = "Ответ удалён"
    redirect_to @topic
  end

  private

  def find_topic
    @topic = Topic.find(params[:topic_id])
  end
end
