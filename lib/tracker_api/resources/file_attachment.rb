module TrackerApi
  module Resources
    class FileAttachment
      include Virtus.model

      attribute :id, Integer
      attribute :filename, String
      attribute :created_at, DateTime
      attribute :uploader_id, Integer
      attribute :thumbnailable, Boolean
      attribute :height, Integer
      attribute :width, Integer
      attribute :size, Integer
      attribute :download_url, String
      attribute :content_type, String
      attribute :uploaded, Boolean
      attribute :big_url, String
      attribute :thumbnail_url, String
      attribute :kind, String

    end
  end
end