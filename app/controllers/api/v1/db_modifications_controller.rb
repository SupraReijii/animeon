module Api
  module V1
    class DbModificationsController < BaseController
      api :POST, '/db_modification/:db_modification_id/approve', 'approve a db modification'
      def approve
        if user_signed_as_admin?
          DbModification.find(params[:db_modification_id]).approve_changes
          render json: DbModification.find(params[:db_modification_id])
        end
      end

      api :POST, '/db_modification/:db_modification_id/rollback', 'rollback a db modification'
      def rollback
        if user_signed_as_admin?
          DbModification.find(params[:db_modification_id]).rollback_changes
          render json: DbModification.find(params[:db_modification_id])
        end
      end

      api :DELETE, '/db_modification/:db_modification_id', 'rollback a db modification'
      def destroy
        if user_signed_as_admin?
          db = DbModification.find(params[:id])
          if db.delete
            render json: 'true'
          end
        end
      end
    end
  end
end
