module ProjectScoped
  extend ActiveSupport::Concern

  included do
    before_action :set_project
  end

  private
    def set_project
      @project = Current.user.projects.find(params[:project_id])
    end
end
