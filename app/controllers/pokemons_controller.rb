class PokemonsController < ApplicationController
  before_action :authorize
  before_action :set_pokemon, only: %i[ show update destroy ]

  # funcao merge sobrepoe dados iguais tenho q passar por cima disso ae
  # GET /pokemons
  def index
    @pokemons = {}
    
    for i in @user.pokemons.all do
      response = JSON.parse RestClient.get("https://pokeapi.co/api/v2/pokemon/#{i.name}")
      @pokemons.merge! response
    end

    # @pokemons = RestClient.get("https://pokeapi.co/api/v2/pokemon/")

    render json: @pokemons
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