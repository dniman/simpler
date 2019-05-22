class TestsController < Simpler::Controller

  def index
    @tests = Test.all
  end

  def create
  end

  def show
    @test = Test[params[:id]]
  end
end
