class IntegrateGoogleAnalytics < ::RailsConnector::Migration
  def up
    preset_attributes
    create_configuration_obj
    deactivate_obj_class
    add_hompage_attribute
    add_homepage_configuration
  end

  private

  def path
    '<%= configuration_path %>/google_analytics'
  end

  def preset_attributes
    update_obj_class(
      '<%= class_name %>',
      preset_attributes: {
        '<%= tracking_id_attribute_name %>' => '<%= tracking_id_default %>',
        '<%= anonymize_ip_attribute_name %>' => '<%= anonymize_ip_default %>',
      }
    )
  end

  def create_configuration_obj
    create_obj(
      _path: path,
      _obj_class: '<%= class_name %>',
      title: 'Google Analytics'
    )
  end

  def deactivate_obj_class
    update_obj_class(
      '<%= class_name %>',
      is_active: false
    )
  end

  def add_hompage_attribute
    attributes = get_obj_class('Homepage')['attributes']
    attributes << '<%= homepage_configuration_attribute_name %>'

    update_obj_class('Homepage', attributes: attributes)
  end

  def add_homepage_configuration
    homepage = Obj.find_by_path('<%= homepage_path %>')
    obj = Obj.find_by_path(path)

    update_obj(
      homepage.id,
      '<%= homepage_configuration_attribute_name %>' => [{ obj_id: obj.id }]
    )
  end
end