class BoardsController < ApplicationController
  # GET /boards
  # GET /boards.json
  def index
    begin
      @user = User.find(session[:id])
    rescue
      reset_session
      @user = User.create
      session[:id] = @user.id
    end

    @board = Board.find(@user.next())

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @board }
    end
  end

  # GET /boards/1
  # GET /boards/1.json
  def show
    return
    @board = Board.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @board }
    end
  end

  # GET /boards/new
  # GET /boards/new.json
  def new
    return
    @board = Board.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @board }
    end
  end

  # GET /boards/1/edit
  def edit
    return
    @board = Board.find(params[:id])
  end

  # POST /boards
  # POST /boards.json
  def create
    return
    #Board.generate()
    #@board = Board.new(params[:board])

    respond_to do |format|
      #if @board.save
        #format.html { redirect_to @board, :notice => 'Board was successfully created.' }
        #format.json { render :json => @board, :status => :created, location: @board }
      #else
        format.html { render :action => "new" }
        format.json { render :json => @board.errors, :status => :unprocessable_entity }
      #end
    end
  end

  # PUT /boards/1
  # PUT /boards/1.json
  def update
    @user = User.find(session[:id])

    if (nil != @user)
      @user.difficulty = params[:id]
    end

    respond_to do |format|
      if @user.save
        format.html { head :no_content }
        format.json { head :no_content }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /boards/1
  # DELETE /boards/1.json
  def destroy
    return
    @board = Board.find(params[:id])
    @board.destroy

    respond_to do |format|
      format.html { redirect_to boards_url }
      format.json { head :no_content }
    end
  end
end
