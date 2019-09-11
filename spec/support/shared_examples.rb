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

shared_examples 'flash[:danger] message' do
  it 'should display flash[:danger]' do
    expect(flash[:danger]).to be_present
  end
end
