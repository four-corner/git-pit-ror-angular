module TrackerApi
  module Endpoints
    class FileAttachment
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def create(project_id, file_name, content_type)
        body = {file: Faraday::UploadIO.new(file_name, content_type)}
        data = client.post("/projects/#{project_id}/uploads", body: body).body
        Resources::FileAttachment.new({ client: client }.merge(data))
      end

    end
  end
end
