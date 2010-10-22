# -*- coding: utf-8 -*-
class PostsController < ApplicationController
  layout 'forum'
  def create
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.build(params[:post].merge(:author => current_user))

    if @post.save
      flash[:notice] = "Ответ создан"
      redirect_to @topic
    else
      render :action => 'new'
    end
  end

  def edit
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:id])
  end

  def update
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:id])

    if @post.update_attributes(params[:post].slice!(:author_id))
      flash[:notice] = "Ответ изменён"
      redirect_to @topic
    else
      render :action => 'edit'
    end
  end

  def destroy
    @topic = Topic.find(params[:topic_id])
    @post = @topic.posts.find(params[:id])

    @post.destroy
    flash[:notice] = "Ответ удалён"
    redirect_to @topic
  end
end
