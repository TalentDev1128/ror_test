class CreateDatetimes < ActiveRecord::Migration[7.0]
  def change
    create_table :datetimes do |t|
      t.datetime :last_request_time

      t.timestamps
    end
  end
end
