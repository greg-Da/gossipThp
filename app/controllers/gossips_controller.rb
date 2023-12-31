class GossipsController < ApplicationController
  before_action :is_logged_in?, except: [:index, :show]
  
  def index
    @gossips = Gossip.all
  end
  
  def show
    @gossip = Gossip.find(params[:id])
    @comments = @gossip.comments
    @comment = Comment.new
  end
  
  def new
    @gossip = Gossip.new()
  end
  
  def create
    @gossip = Gossip.new(title: params[:title], content: params[:content], user: User.find_by(id: session[:user_id]))
    
    if @gossip.save
      flash[:success] = "Potins créé"
      redirect_to gossips_path
    else
      render :new
    end
  end
  
  def edit
    @gossip = Gossip.find(params[:id])
    if @gossip.user != current_user
      flash[:warning] = "Tu n'en es pas l'auteur"
      redirect_back_or_to root_path
    end
  end
  
  def update
    @gossip = Gossip.find(params[:id])
    
    if @gossip.user == current_user
      
      @gossip.title = params[:title]
      @gossip.content = params[:content]
      
      if @gossip.save
        flash[:success] = "Potins édité"
        redirect_to gossip_path(@gossip.id)
      else
        render :edit
      end
      
    else
      flash[:warning] = "Tu n'en es pas l'auteur"
      redirect_back_or_to root_path
    end
  end
  
  def destroy
    @gossip = Gossip.find(params[:id])

    if @gossip.user == current_user
      
      @gossip.destroy
      flash[:warning] = "Supression du potin"
      redirect_to root_path
    else
      flash[:warning] = "Tu n'en es pas l'auteur"
      redirect_back_or_to root_path
    end
  end
  
end
