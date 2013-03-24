class Box::BoxSliderCell < BoxCell
  # Cell actions:

  def show(page, box)
    @id = box.id
    @images = box.slider_images

    if @images.present?
      super(page, box)
    end
  end

  def image(image, index)
    @image = image
    @index = index
    @class_name = index == 0 ? 'active' : nil

    render
  end

  # Cell states:
  # The following states assume @id and @images to be given.

  def indicators
    render
  end

  def images
    render
  end

  def control(direction)
    @direction = direction

    if @direction == :prev
      render(view: 'left_control')
    else
      render(view: 'right_control')
    end
  end

  def javascript_id
    "##{@id}"
  end

  # The following states assume @image to be given.

  def title
    if @image.title.present?
      render
    end
  end
end