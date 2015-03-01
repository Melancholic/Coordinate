<% provide(:title,'Edit profile') %> 
<div class="center hero-unit">
  <h1>Update your profile</h1>  
</div>
<div class="row">
  <div class="span6 offset3">
      <%= render('shared/error_msgs') %>
      <div>
        <aside class ="span4">
        <section>
        <%= gravatar_for(@user,size:150)  %>
        <%= link_to("Change Gravatar","http://gravatar.com/emails" ,:target => "_blank") %>
        </section>
        </aside>
      </div>
    <%= form_for(@user) do |f| %>

      <%= f.label :name %>
      <%= f.text_field(:name) %>

      <%= f.label :email %>
      <%= f.text_field :email %>


      <%= f.label :password %>
      <%= f.password_field :password %>

      <%= f.label :password_confirmation, "Confirmation" %>
      <%= f.password_field  :password_confirmation %>

      <br>
      <%= f.submit("Save changes", class: "btn btn-large btn-primary") %>
    <% end %>

  </div>
</div>


