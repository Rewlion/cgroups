require 'spec_helper'


describe 'parse_cgroups_json' do 

  context "wrong JSON format" do

      let(:params) {
        {
          "apache" => '{{"CPUShares":1200}'
        }}

      it 'should raise if settings have wrong JSON format' do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end

  context "should not parse a data with type different from Hash" do

      let(:params) {
          'cinder-api:{"TasksMax":500, "MemoryLimit":"1G"}'
      }

      it 'should raise if group option is not a Hash' do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end

  context "should not parse a data with property value's type different from string,int" do

      let(:params) {
        {
          "cinder-api" => '{"TasksMax":[500,1]}'
        }
      }

      it 'should raise if property value is an array' do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end

  ###########################
  context 'CPUAccounting with bool value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"CPUAccounting" : "true"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "CPUAccounting" => "true" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


  context "CPUAccounting with int value" do

      let(:params) {
        {
          "cinder-api" => '{"CPUAccounting":"200"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


  context 'CPUShares with valid value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"CPUShares" : "300"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "CPUShares" => "300" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


context "CPUShares with invalid value" do

      let(:params) {
        {
          "cinder-api" => '{"CPUShares":"FOO"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end

  context "CPUShares with invalid value(lover min)" do

      let(:params) {
        {
          "cinder-api" => '{"CPUShares":"1"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


  context "CPUShares with invalid value(bigger max)" do

      let(:params) {
        {
          "cinder-api" => '{"CPUShares":"300000"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


    context 'CPUQuota with valid value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"CPUQuota" : "50%"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "CPUQuota" => "50%" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


    context 'CPUQuota with valid value' do

      let(:params) {
        {
          "cinder-api" => '{"CPUQuota":"200"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


    context 'MemoryLimit with valid value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"MemoryLimit" : "1024M"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "MemoryLimit" => "1024M" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


context "MemoryLimit with invalid value" do

      let(:params) {
        {
          "cinder-api" => '{"MemoryLimit":"200FOO"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


    context 'TasksMax with valid value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"TasksMax" : "22"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "TasksMax" => "22" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


context "TasksMax with invalid value" do

      let(:params) {
        {
          "cinder-api" => '{"TasksMax":"FOO"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


    context 'BlockIODeviceWeight with valid value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"BlockIODeviceWeight" : "/dev/sda1 10"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "BlockIODeviceWeight" => "/dev/sda1 10" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


context "BlockIODeviceWeight with invalid value by syntax" do

      let(:params) {
        {
          "cinder-api" => '{"BlockIODeviceWeight":"foo"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end

context "BlockIODeviceWeight with invalid value( > 1k )" do

      let(:params) {
        {
          "cinder-api" => '{"BlockIODeviceWeight":"1000000"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end

context "BlockIODeviceWeight with invalid value( < 10 )" do

      let(:params) {
        {
          "cinder-api" => '{"BlockIODeviceWeight":"0"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


context 'BlockIOReadBandwidth with valid value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"BlockIOReadBandwidth" : "/dev/disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0 5M"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "BlockIOReadBandwidth" => "/dev/disk/by-path/pci-0000:00:1f.2-scsi-0:0:0:0 5M" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


context "BlockIOReadBandwidth with invalid value" do

      let(:params) {
        {
          "cinder-api" => '{"CPUAccounting":"foo"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


context 'DeviceAllow with valid value' do 
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api"  =>  '{"DeviceAllow" : "/dev/sdb1 r"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "DeviceAllow" => "/dev/sdb1 r" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end


context "DevicePolicy with valid value" do
    let(:params) {
        {
          'metadata' => {
            'always_editable' => true,
            'group' => 'general',
            'label' => 'Cgroups',
            'weight' => 50
          },
          "cinder-api" => '{"DevicePolicy" : "strict"}'
        } }

        let(:result) {
        {
          "cinder-api"  => { "DevicePolicy" => "strict" },
        }}
    

        it 'should parse valid hash' do
          is_expected.to run.with_params(params).and_return(result)
    end
  end

context "DevicePolicy with invalid value" do

      let(:params) {
        {
          "cinder-api" => '{"DevicePolicy" : "FOO"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end



context "Unknown property" do

      let(:params) {
        {
          "cinder-api" => '{"UNKNOWN" : "FOO"}'
        }
      }

      it  do
          is_expected.to run.with_params(params).and_raise_error(RuntimeError)
    end
  end


 end