class Admin::Config::ShippingRatesController < Admin::Config::BaseController
  # GET /shipping_rates
  # GET /shipping_rates.xml
  def index
    form_info
    if @shipping_methods.empty?
      flash[:notice] = 'You need a Shipping Method before you create a shipping rate.'
      redirect_to admin_config_shipping_methods_url
    else
      @shipping_rates = ShippingRate.includes([:shipping_method, :shipping_rate_type]).all
    end
  end

  # GET /shipping_rates/1
  # GET /shipping_rates/1.xml
  def show
    @shipping_rate = ShippingRate.find(params[:id])
  end

  # GET /shipping_rates/new
  # GET /shipping_rates/new.xml
  def new
    form_info
    if @shipping_categories.empty?
        flash[:notice] = "You must create a Shipping Category before you create a Shipping Rate."
        redirect_to new_admin_config_shipping_category_url
    elsif @shipping_methods.empty?
        flash[:notice] = "You must create a Shipping Method before you create a Shipping Rate."
        redirect_to new_admin_config_shipping_method_url
    else
      @shipping_rate = ShippingRate.new
    end
  end

  # GET /shipping_rates/1/edit
  def edit
    @shipping_rate = ShippingRate.find(params[:id])
    form_info
  end

  # POST /shipping_rates
  # POST /shipping_rates.xml
  def create
    @shipping_rate = ShippingRate.new(params[:shipping_rate])

    respond_to do |format|
      if @shipping_rate.save
        format.html { redirect_to(admin_config_shipping_rate_url(@shipping_rate), :notice => 'Shipping rate was successfully created.') }
      else
        form_info
        format.html { render :action => "new" }
      end
    end
  end

  # PUT /shipping_rates/1
  # PUT /shipping_rates/1.xml
  def update
    @shipping_rate = ShippingRate.find(params[:id])

    respond_to do |format|
      if @shipping_rate.update_attributes(params[:shipping_rate])
        format.html { redirect_to(admin_config_shipping_rate_url(@shipping_rate), :notice => 'Shipping rate was successfully updated.') }
      else
        form_info
        format.html { render :action => "edit" }
      end
    end
  end

  # DELETE /shipping_rates/1
  # DELETE /shipping_rates/1.xml
  def destroy
    @shipping_rate = ShippingRate.find(params[:id])
    @shipping_rate.destroy
    redirect_to(admin_config_shipping_rates_url)
  end

  private

  def form_info
    @shipping_rate_types  = ShippingRateType.all.map{|srt| [srt.name, srt.id]}
    @shipping_methods     = ShippingMethod.all.map{|sm| [sm.name, sm.id]}
    @shipping_categories  = ShippingCategory.all.map{|sc| [sc.name, sc.id]}
  end
end
