class GetThumbnails

  def self.call(thumblist)
    thumblist.each do |id|
      ThumbnailsWorker.perform_async(id)
    end
  end

  def self.save_snapshot_to_s3(new_bookmark)
    file = File.open(AddSnapshot.call(new_bookmark.url, new_bookmark.id))
    ## We presently increment Snapshot.id manually to sync up with Extension Import
    new_snapshot = Snapshot.new(bookmark_id: new_bookmark.id, id: Snapshot.count+1)
    new_snapshot.thumbnail = file # snapshot.save
    file.close
    new_snapshot.save! # snapshot.save
  end

end