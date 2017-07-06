#Level 1 
----------------------------------
# Veri tabanından zombies olmalı. Find metodu için.
z = Zombie.find(1)

# Create metodu için. Parantez içindekiler sıraykla veri tabanındaki sırayla olmalı.
z = Zombie.create(id: '4',name: "Nafi",graveyard: "Condşmental")

#bütün isimleri listelemek icin
Zombie.order(:name)

#güncelleme
z = Zombie.find(2)
z.attributes = {name: "isim" , graveyard: "yer"}
z.save
------------------
z = Zombie.find(2)
z.update(name: "isim", graveyard: "yer")

-----------------------------------------------------

#Level 2 

#Model yaratma.
class Zombie < ActiveRecord::Base
end

#isim ekleme
class Zombie < ActiveRecord::Base
  validates_presence_of :name
end

#diger kullanım yerleri
validates_presence_of :
validates_numericality_of :
validates_uniqueness_of :
validates_confirmation_of :
validates_acceptance_of :
validates_length_of :password , minimum : 3 # gibi
validates_format_of :email, with: /regex/i
validates_inclusion_of :age, in: 21..99
validates_exclusion_of :age, in: 0..21, message: "Sorry"
 
#tablolar arasında baglantı saglama
 class Weapon < ActiveRecord::Base
  belongs_to :zombie #burası tekil olmalı
end

z = Zombie.find(1)
z.weapons
----------------------------
#Level 3

#view simple / html kodlarını erb olarak yazma
<% zombie = Zombie.first %>
<h1><%= zombie.name %></h1> #zombie tekil olmalı

<p>
  <%= zombie.graveyard %>
</p>

#linking

<% zombie = Zombie.first %>
<p>
<%= link_to zombie.name, zombie_path(zombie) %>
---------------
<%= link_to zombie.name, zombie %> # alternatif
</p>
----------------
# each blocks
<ul>
<% zombies.each do |zombie| %>
  <li><%= zombie.name %></li>
<% end %>
</ul>

# İF 

<ul>
  <% zombies.each do |zombie| %>
    <li>
      <%= zombie.name %>
      <% if zombie.tweets.size > 1 %>
      SMART ZOMBIE 
      <% end %>
    </li>
  <% end %>
</ul>

# linking in blocks

<ul>
  <% zombies.each do |zombie| %>
    <li>
      <%= link_to zombie.name, edit_zombie_path(zombie) %>
    </li>
  <% end %>
</ul>

---------------------------
# Level 4

#show action 

class ZombiesController < ApplicationController
  def show
    @zombie = Zombie.find(params[:id])
  end
end

# respond to 

class ZombiesController < ApplicationController
  def show
    @zombie = Zombie.find(params[:id])

    respond_to do |format|
    
      format.xml { render xml: @zombie }

    end
  end
end

# def index , show , new , edit , create , update , destroy # şeklinde kullanılabilir.

# Controller create action

class ZombiesController < ApplicationController
  def create
    @zombie = Zombie.create(zombie_params)
    redirect_to zombie_path(@zombie)

  end

  private

  def zombie_params
    params.require(:zombie).permit(:name, :graveyard)
  end
end

# Controller before action

class ZombiesController < ApplicationController
  before_action :find_zombie
  before_action :check_tweets, only: :show

  def show
    render action: :show
  end

  def find_zombie
    @zombie = Zombie.find params[:id]
  end
  
  def check_tweets
    if @zombie.tweets.size == 0
      redirect_to zombies_path
    end
  end
  
end

--------------------------
# Level 5

# resource route

TwitterForZombies::Application.routes.draw do
  resources :zombies # coğul olmalı
end

# route matching 

TwitterForZombies::Application.routes.draw do
  resources :zombies
  get '/undead' => 'zombies#undead'

end

# route redirecting

TwitterForZombies::Application.routes.draw do
  get '/undead' =>  redirect('/zombies')

end

# root route

TwitterForZombies::Application.routes.draw do
  root to: 'zombies#index'
end

#named route

TwitterForZombies::Application.routes.draw do
  get '/zombies/:name', to: 'zombies#index', :as => 'graveyard'
end





