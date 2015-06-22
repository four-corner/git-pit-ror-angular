module TrackerApi
  module Endpoints
    class Project
      attr_accessor :client

      def initialize(client)
        @client = client
      end

      def get(id, params={})
        data = client.get("/projects/#{id}", params: params).body

        Resources::Project.new({ client: client }.merge(data))
      end

      def create(params={})
        data = client.post("/projects", params: params).body

        Resources::Project.new({ client: client }.merge(data))
      end

      def update(id, params={})
        data = client.put("/projects/#{id}", params: params).body

        Resources::Project.new({ client: client }.merge(data))
      end

      def delete(id)
        client.delete("/projects/#{id}").body
      end

    end
  end
end
