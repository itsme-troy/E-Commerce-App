class TagsController < ApplicationController
    # callback method that runs "set_tag" method 
    # before edit, update and destroy, actions 
    # loads @tag based on its ID to avoid code repetition
    before_action :set_tag, only: [:edit, :update, :destroy, :show]

    # runs when /tags is visited 
    # fetches all tags from database and store them in @tags 
    def index 
        if params[:query].present? 
            @tags = Tag.where("name LIKE ?", "%#{params[:query]}%")
        else 
            @tags = Tag.all 
        end
    end

    def show
    end

    # prepares an empty tag object for the form in new.html.erb 
    def new 
        @tag = Tag.new 
    end

    # Creates a new tag with the form input (e.g. name).
    # tag_params filters which fields can be saved 
    def create 
        @tag = Tag.new(tag_params)
        # tries to save the tag to DB 
        if @tag.save
            redirect_to tags_path, notice: "Tag created successfully!"
        # display the form again and keep the error message
        else 
            render :new, status: :unprocessable_entity
        end
    end

    # loads tag for the edit form 
    def edit
    end

    # updates the selected tag with new values from the form 
    def update
        if @tag.update(tag_params)
            redirect_to tags_path, notice: "Tags updated successfully!"
        else 
            render :edit, status: unprocessable_entity
        end
    end

    # Deletes the selected tag from the database.
    def destroy
        @tag.destroy
        redirect_to tags_path, notice: "Tag deleted successfully!"
    end

    private
    # Finds the tag by its ID from the URL (like /tags/5/edit).
    # Assigns it to @tag so it can be used in edit, update, and destroy.
    def set_tag
        @tag = Tag.find(params[:id])
    end

    # strong parameters metod to prevent mass assignment 
    # allows name field in the form to be saved
    # protects the app from people trying to submit unwanted fields
    def tag_params
        params.require(:tag).permit(:name)
    end
end
