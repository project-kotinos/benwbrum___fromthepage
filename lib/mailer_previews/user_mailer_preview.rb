class UserMailerPreview < ActionMailer::Preview

  def upload_finished
    UserMailer.upload_finished(DocumentUpload.last)
  end

  def new_owner
    block = PageBlock.find_by(view: "new_owner").html
    user = User.find_by(login: 'admin')
    UserMailer.new_owner(user, block)
  end

  def added_note
    user = User.find_by(login: 'admin')
    note = Note.first
    UserMailer.added_note(user, note)
  end

end
