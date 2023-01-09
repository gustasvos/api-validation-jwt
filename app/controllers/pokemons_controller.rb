class PokemonsController < ApplicationController
  before_action :authorize
  before_action :set_pokemon, only: %i[ show update destroy ]

  # GET /pokemons
  def index
    @pokemons = @user.pokemons.all

    @pokemons.each do |p|
      @pokemons_data = RestClient.get("https://pokeapi.co/api/v2/pokemon/#{p.name}")
    end

    # @pokemons_data = RestClient.get()
    # @pokemons = RestClient.get("https://pokeapi.co/api/v2/pokemon/")

    render json: @pokemons_data
  end

  # GET /pokemons/1
  def show
    render json: @pokemon
  end

  # POST /pokemons
  def create
    @pokemon = Pokemon.new(pokemon_params)

    if @pokemon.save
      render json: @pokemon, status: :created, location: @pokemon
    else
      render json: @pokemon.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pokemons/1
  def update
    if @pokemon.update(pokemon_params)
      render json: @pokemon
    else
      render json: @pokemon.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pokemons/1
  def destroy
    @pokemon.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_pokemon
      @pokemon = Pokemon.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def pokemon_params
      params.require(:pokemon).permit(:name, :user_id)
    end
end
