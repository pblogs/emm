class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new

    # Users
    can [:index, :show], User # anybody can see user

    # Albums
    can [:index], Album # anybody can see user's albums (restrictions for private albums applied in albums#index)
    can [:show], Album do |album| # anybody can see public album
      album.for_all?
    end
    # Photos, Videos, Texts
    can [:show], [Photo, Video, Text] do |media| # anybody can see media inside public album, OR if media is pinned on main page
      media.record.album.for_all? || media.tile.present?
    end
    # Records
    can [:index], Record # anybody can see records (restrictions for private albums applied in records#index)
    can [:show], Record do |record| # anybody can see record inside public album
      record.album.for_all?
    end
    # Tiles and Pages
    can [:index, :show], Tile # anybody can see user's tiles (even for private medias and albums)
    can [:index, :show], Page # anybody can see tiles, so anybody can see pages
    # Comments, Tags
    can [:index], [Comment, Tag] # anybody can see comments and tags for resource if he can see resource itself (load_and_authorize_target in controllers)
    # Likes
    # nobody can see likes
    # Relationships
    can [:index, :show], Relationship # anybody can see user's friends
    # Tributes
    can [:index, :show], Tribute # anybody can see user's tributes


    # ADMIN can manage ALL
    if user.admin?
      can :manage, :all


    # REGISTERED USERS
    elsif user.persisted?
      # Users
      can [:update], User, id: user.id # user can update itself

      # Albums
      can :manage, Album, user_id: user.id # user can manage his albums
      can [:show], Album do |album| # friend can see albums "For friends"
        album.for_friends? && user.is_friend?(album.user_id)
      end
      # Photos, Videos, Texts
      can :upload, Video # user can upload video
      can :manage, [Photo, Video, Text] do |media| # user can manage his medias
        media.album.user_id == user.id
      end
      # Records
      can :manage, Record do |record| # user can manage his records
        record.album.user_id == user.id
      end
      # Tiles and Pages
      can :manage, Tile do |tile| # user can manage his tiles
        tile.page.user_id == user.id
      end
      can :manage, Page, user_id: user.id # user can manage his pages
      # Comments
      can [:create], Comment # registered user can create comments if he can see resource itself (load_and_authorize_target in controllers)
      can [:update], Comment, author_id: user.id # comment's author can update comment
      can [:destroy], Comment do |comment| # comment's author OR author of commentable resource can destroy comment
        comment.commentable.user.id == user.id || comment.author_id == user.id
      end
      # Tags
      can [:create], Tag do |tag| # author of taggable resource can tag users on it
        tag.target.user_id == user.id
      end
      can [:destroy, :pin_record], Tag do |tag| # author of taggable resource can untag users from it OR tagged person can untag himself
        tag.author_id == user.id || tag.user_id == user.id
      end
      # Likes
      can [:create, :destroy], Like # registered user can like if he can see resource itself (load_and_authorize_target in controllers)
      # Relationships
      can [:create], Relationship # registered users can offer a friendship to other user
      can [:update], Relationship, recipient_id: user.id # friendship recipient can accept/decline invitation
      can [:destroy], Relationship do |relation| # one of friends can broke relationship
        relation.accepted? && (relation.sender_id == user.id || relation.recipient_id == user.id)
      end
      # Tributes
      can [:create], Tribute do |tribute| # registered user can leave tribute to his friend
        user.is_friend?(tribute.user_id)
      end
      can [:update], Tribute, author_id: user.id # tribute's author can update tribute
      can [:destroy], Tribute do |tribute| # tribute's author OR tributed user can destroy comment
        tribute.user_id == user.id || tribute.author_id == user.id
      end
      #Newsfeed
      can :index, :news_feed
    end
  end
end
