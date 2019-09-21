shared_examples 'require_sign_in' do
  it 'should redirect to the front page' do
    clear_current_user
    action
    expect(response).to redirect_to root_path
  end
end

shared_examples 'flash[:success] message' do
  it 'should display flash[:success]' do
    expect(flash[:success]).to be_present
  end
end

shared_examples 'flash[:info] message' do
  it 'should display flash[:info]' do
    expect(flash[:info]).to be_present
  end
end

shared_examples 'flash[:warning] message' do
  it 'should display flash[:warning]' do
    expect(flash[:warning]).to be_present
  end
end

shared_examples 'flash[:danger] message' do
  it 'should display flash[:danger]' do
    expect(flash[:danger]).to be_present
  end
end

shared_examples 'ActiveModel' do
  include ActiveModel::Lint::Tests

  # to_s is to support ruby-1.9
  ActiveModel::Lint::Tests.public_instance_methods.map{|m| m.to_s}.grep(/^test/).each do |m|
    example m.gsub('_', ' ') do
      send m
    end
  end
  def model
    subject
  end
end
