class Picture
  attr_accessor :name

  def initialize(desc, data, audio_file)
    #num = audio_file.instance_variable_get(:@pic_count) || 0
    #num += 1
    #audio_file.instance_variable_set(:@pic_count, num)
    @data = data
    @name="audio_files/#{audio_file.id}/pictures/#{desc}"
    upload
  end

  def connection
    @connection ||= AWS::S3.new({
                                    :access_key_id => ENV["S3_KEY"],
                                    :secret_access_key => ENV["S3_SECRET"]
                                })
  end

  def bucket_name
    Rails.application.secrets.s3_bucket
  end

  def bucket
    connection.buckets[bucket_name]
  end

  def upload
    bucket.objects[name].write(@data, :acl => :public_read)
  end

  def url
    bucket.objects[name].public_url.to_s
  end
end