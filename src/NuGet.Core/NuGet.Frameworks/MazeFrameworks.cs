using System.Collections.Generic;

namespace NuGet.Frameworks
{
    public static class MazeFrameworks
    {
        public static
#if NET40
IDictionary
#else
IReadOnlyDictionary
#endif

            <NuGetFramework, NuGetFramework> MazeNetFrameworks
        {
            get
            {
                return new Dictionary<NuGetFramework, NuGetFramework>(NuGetFramework.Comparer)
                {
                    {
                        FrameworkConstants.CommonFrameworks.MazeServer10,
                        FrameworkConstants.CommonFrameworks.NetCoreApp21
                    },
                    {
                        FrameworkConstants.CommonFrameworks.MazeAdministration10,
                        FrameworkConstants.CommonFrameworks.Net47
                    },
                    {
                        FrameworkConstants.CommonFrameworks.MazeClient10,
                        FrameworkConstants.CommonFrameworks.Net47
                    }
                };
            }
        }

        public static NuGetFramework MapToNetFramework(NuGetFramework mazeFramework)
        {
            return MazeNetFrameworks[mazeFramework];
        }

        public static bool IsMazeFramework(NuGetFramework framework)
        {
            return MazeNetFrameworks.ContainsKey(framework);
        }
    }
}