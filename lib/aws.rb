module Aws
  require 'time'
  require 'aws'
  #a init method to be used for initialisation when the rails application start
  def self.init
    @@dynamo_table = false
    @@dynamo_db = false
    if AWS_SETTINGS["aws_dynamo"]
      @@dynamo_db = AWS::DynamoDB.new(AWS_SETTINGS["aws_dynamo"])
    end
  end
  #the method that save in aws database
  def self.save_records_to_db(params)
    return if !@@dynamo_db
    #set the table name, hash_key and range_key from the AmazonDB
    @@dynamo_table = @@dynamo_db.tables['records']
    @@dynamo_table.hash_key = [:member_id, :number]
    @@dynamo_table.range_key = [:datetime, :string]
    fields = {
        'member_id' => 1, #primary partition key
        'datetime' => Time.now.utc.iso8601, #primary sort key
    }
    fields.merge!(params[:custom_fields]) if params[:custom_fields]
    @@dynamo_table.items.create(fields)
  end
end
