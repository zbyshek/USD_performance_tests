#ifdef _WIN32
#define NOMINMAX
#endif

#include <iostream>
#include <string>
#include <cstddef>

#include <pxr/pxr.h>
#include <pxr/usd/usd/prim.h>
#include <pxr/usd/usd/stage.h>
#include <pxr/usd/sdf/path.h>
#include <pxr/base/tf/stopwatch.h>
#include <pxr/base/tf/debug.h>

PXR_NAMESPACE_USING_DIRECTIVE

TF_CONDITIONALLY_COMPILE_TIME_ENABLED_DEBUG_CODES(
  /*enabled=*/true,
  INFO
);

std::string BoolToString(const bool& b)
{
  return b ? "true" : "false";
}

/*
Just for a curious performance test. While using SdfChangeBlock changes should be performed directly
via the Sdf API without talking to downstream libraries like UsdStage below in this function.
*/
void CreateOverridePrims(const UsdStageRefPtr& stage, const SdfPathVector& vec)
{
  size_t count = 0;
  SdfChangeBlock change_block;
  
  for (const auto& path : vec)
  {
    stage->OverridePrim(path.AppendElementString("group_" + TfIntToString(count)));
    ++count;
  }
}

// Creating OverridePrim via Sdf API
void CreateOverridePrims(const SdfLayerRefPtr& layer, const SdfPathVector& vec)
{
  size_t count = 0;
  SdfChangeBlock change_block;

  for (const auto& path : vec)
  {
    SdfJustCreatePrimInLayer(layer, path.AppendElementString("group_" + TfIntToString(count)));
    ++count;
  }
}

int main(int argc, char* argv[])
{
  if (argc != 3)
  {
    std::cerr << "Usage: " << argv[0] << " <Input USD file> <Output Usd File>\n";
    return 1;
  }
  UsdStageRefPtr stage = UsdStage::Open(argv[1]);
  if (!stage)
  {
    std::cerr << "Failed to open USD file: " << argv[1] << "\n";
    return 1;
  }

  TfDebug::Enable(INFO);
  TfStopwatch watch;

  // Run
  watch.Start();
  UsdPrim def_prim = stage->GetDefaultPrim();
  if (!def_prim.IsValid())
  {
    std::cerr << "Default prim isn't defined: " << "\n";
    return 1;
  }
  
  SdfPath def_prim_path = def_prim.GetPath();
  SdfLayerRefPtr rootLayerPtr = stage->GetRootLayer();
  SdfPathVector vec(250000, def_prim_path.AppendElementString("test"));
  CreateOverridePrims(rootLayerPtr, vec);
  
  watch.Stop();
  TF_INFO(INFO).Msg("Run time : %f s\n", watch.GetSeconds());
  
  std::string filename = argv[2];
  bool is_exported = rootLayerPtr->Export(filename);
  TF_INFO(INFO).Msg("Stage is exported: %s\n", BoolToString(is_exported));
  return 0;
}